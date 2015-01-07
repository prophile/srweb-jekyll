
var app = angular.module('app', ["competitionFilters", "competitionResources"]);

app.controller("CompMode", function($scope, Arenas, AllMatches, LeagueScores, MatchesFactory, State, Teams) {

    $scope.upcoming_match = {};
    $scope.next_match = {};
    $scope.current_match = {};
    $scope.previous_match = {};

    Teams.follow(function(teams) {
        $scope.teams = teams;
    });

    // because this changes as a result of two things, do our own updating.
    // Idealy this would be a filter in the template, but that didn't want
    // to work easily.
    var all_matches = [];
    var next_match = 0;
    var refresh = function() {
        var low = Math.max(0, next_match-2);
        $scope.matches = all_matches.slice(low, low+10);
    };

    // update our current/next information all the time
    // it will change as time passes, even if the state revision doesn't
    var store_map = {
        "previous": "previous_match",
        "current": "current_match",
        "next": "next_match",
        "next+1": "upcoming_match"
    };
    var updateState = function(MatchState, arena) {
        MatchState.get(function(matches) {
            matches = matches.matches;
            for (var i=0; i<matches.length; i++) {
                var match = matches[i];
                if (match.query == "next") {
                    next_match = match.num;
                }
                if (match.query in store_map) {
                    var name = store_map[match.query];
                    var item = null, num = null;
                    if (!match.error) {
                        item = match;
                        num = match.num;
                    }
                    if ($scope[name].games == null) {
                        $scope[name].games = {};
                    }
                    $scope[name].games[arena] = item;
                    // TODO: avoid storing this in two places
                    // done for the moment to achieve a minimal patch
                    $scope[name].num = num;
                    $scope[name + "_number"] = num;
                }
            }
            refresh();
        });
    };

    // update the data only when the state changes
    State.change(function() {
        // TODO: consider getting only the matches of interest,
        // once there's an easy way to do this for all arenas at once.
        AllMatches.get(function(nodes) {
            all_matches = convert_matches(nodes.matches);
            refresh();
        });

        LeagueScores.get(function(points) {
            var league_points = league_sorter(points.league_points, null, points.game_points);
            $scope.league_points = league_points.slice(0, 10);
        });
    });

    Arenas.get(function(nodes) {
        $scope.arenas = nodes.arenas;
        var per_arena = function(arena) {
            var MatchState = MatchesFactory(arena, "previous,current,next,next+1");
            var update = function() {
                updateState(MatchState, arena);
            };
            // refresh every 10s
            setInterval(update, 10000);
            update();
        };
        for (var i=0; i<$scope.arenas.length; i++) {
            per_arena($scope.arenas[i]);
        }
    });
});
