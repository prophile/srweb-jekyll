
var app = angular.module('app', ["competitionFilters", "competitionResources"]);

app.controller("KnockoutTree", function($scope, $log, Arenas, Corners, Current, KnockoutMatches, LastScoredMatch, MatchPeriods, State, Teams, Tiebreaker) {

    $scope.unknowable = UNKNOWABLE_TEAM;
    var KNOCKOUT_TYPE = "knockout";

    $scope.corners = [];
    Corners.load(function(cornerId, corner) {
        $scope.corners[cornerId] = corner;
    });

    var update_knockout_started = function(now) {
        if ($scope.knockout_start == null) {
            // can't do anything if we don't know when they start
            return;
        }
        if (now == null && $scope.offset != null) {
            now = Current.timeFromOffset($scope.offset);
        }
        if (now == null) {
            // can't do anything if we don't know what time it is.
            $log.warn("Cannot update knockout state without knowing the current server time or offset");
            return;
        }
        $scope.knockout_started = $scope.knockout_start < now;
    };

    // update our current/next information all the time
    // it will change as time passes, even if the state revision doesn't
    Current.follow(function(nodes) {
        if (nodes.matches.length > 0) {
            var match = nodes.matches[0];
            $scope.current_match = match.num;
        } else {
            $scope.current_match = null;
        }

        $scope.offset = nodes.offset;
        update_knockout_started(nodes.time);
    });

    // update the data only when the state changes
    State.change(function() {
        Arenas.get(function(nodes) {
            $scope.arenas = nodes.arenas;
        });

        Teams.get(function(nodes) {
            $scope.teams = nodes.teams;
        });

        MatchPeriods.get(function(nodes) {
            var knockout_period;
            for (var i = 0; i < nodes.periods.length; i++) {
                if (nodes.periods[i].type === 'knockout') {
                    knockout_period = nodes.periods[i];
                    break;
                }
            }

            if (knockout_period) {
                $scope.knockout_start = new Date(knockout_period.start_time);
                update_knockout_started();
            }
        });

        LastScoredMatch.get(function(points) {
            $scope.latest_scored_match = points.last_scored;
        });

        KnockoutMatches.get(function(nodes) {
            // perform the request, however the callback is guaranteed to be
            // called after the code below this chunk
            Tiebreaker.get(function(tiebreaker) {
                $scope.rounds = process_knockouts(nodes.rounds,
                                                  tiebreaker.tiebreaker);
            });

            // load knockouts first in case there is no tiebreaker
            $scope.rounds = process_knockouts(nodes.rounds);
        });
    });
});
