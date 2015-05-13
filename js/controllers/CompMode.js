
var app = angular.module('app', ["competitionFilters", "competitionResources", "ordinal"]);

app.controller("CompMode", function($scope, $interval, $log, Arenas, AllMatches, Current, State, Teams) {

    $scope.matches = [];
    // NB: These must be inited to objects, see below
    $scope.upcoming_match = {};
    $scope.next_match = {};
    $scope.current_match = {};
    $scope.previous_match = {};

    var grouped_matches = [];

    var first_value = function(map) {
        for (var k in map) {
            return map[k];
        }
    };

    // Each of the _match items is used within an 'include'. These work
    // by creating a new scope upfront, taking a reference to the value
    // within the named item. As a result, we need to update the original
    // value rather than just replacing it.
    // See http://stackoverflow.com/a/15937197/67873 for a more detailed
    // explanation.
    var set_match_info = function(name, games) {
        var info = $scope[name];
        if (!games) {
            info.exists = false;
            info.num = null;
            info.display_name = null;
            info.games = null;
        } else {
            info.exists = true;
            var game = first_value(games);
            info.num = game.num;
            info.display_name = game.display_name;
            info.games = games;
        }
    };

    $scope.time_offset = 0;
    Current.follow(function(nodes) {
        $scope.time_offset = nodes.offset;
        var grouped = group_matches(nodes.matches);
        set_match_info('current_match', grouped[0]);
    });

    $interval(function() {
        var now = Current.timeFromOffset($scope.time_offset);

        var previous_matches = grouped_matches.filter(function(game_map) {
            var game = first_value(game_map);
            return new Date(game.times.slot.end) < now;
        });
        // last one
        var previous_match = previous_matches[previous_matches.length - 1];
        set_match_info('previous_match', previous_match);

        var upcoming_matches = grouped_matches.filter(function(game_map) {
            var game = first_value(game_map);
            return new Date(game.times.slot.start) > now;
        });

        set_match_info('next_match', upcoming_matches[0]);
        set_match_info('upcoming_match', upcoming_matches[1]);
    }, 100);

    // update the data only when the state changes
    State.change(function() {
        var data = {};
        function set_matches(data) {
            if (data.matches == null || data.arenas == null) {
                // don't have all the data yet, wait until we do (we'll
                // be called again when that happens).
                return;
            }

            all_matches = data.matches;
            grouped_matches = group_matches(all_matches);
            $scope.matches = convert_matches(grouped_matches, data.arenas);
            $scope.arenas = data.arenas;
        }

        Arenas.get(function(nodes) {
            data.arenas = nodes.arenas;
            set_matches(data);
        });

        Teams.get(function(nodes) {
            $scope.teams = nodes.teams;
        });

        // TODO: consider getting only the matches of interest,
        // once there's an easy way to do this for all arenas at once.
        AllMatches.get(function(nodes) {
            data.matches = nodes.matches;
            set_matches(data);
        });
    });
});

app.filter("matchesEndingAfterNow", function(Current) {
    return function(matches, time_offset) {
        if (!matches) {
            return [];
        }
        var now = Current.timeFromOffset(time_offset);
        return matches.filter(function(match) {
            return match.end_time > now;
        });
    };
});

app.filter("leaderboard", function() {
    return function(teams, limit) {
        var output = [];
        for (var tla in teams) {
            output.push(teams[tla]);
        }
        output.sort(function(a, b) {
            return a.league_pos - b.league_pos;
        });
        if (limit) {
            output = output.slice(0, limit);
        }
        return output;
    };
});
