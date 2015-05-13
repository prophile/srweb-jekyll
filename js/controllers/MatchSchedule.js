
var app = angular.module('app', ["ngStorage", "competitionFilters", "competitionResources", "ui.select2"]);

app.controller("MatchSchedule", function($scope, $sessionStorage, Corners, Current, MatchPeriods, State, Teams) {

    $scope.$storage = $sessionStorage.$default({hideOldMatches: true});

    var sessions_cache = {};
    $scope.$watch("$storage.hideOldMatches", function(value) {
        $scope.sessions = sessions_cache[value];
    });

    $scope.corners = [];
    Corners.load(function(cornerId, corner) {
        $scope.corners[cornerId] = corner;
    });

    var sessions_changed = function(sessions) {
        sessions_cache[false] = sessions;
        sessions_cache[true] = unspent_matches(sessions, true);
        $scope.sessions = sessions_cache[$sessionStorage.hideOldMatches];
    };

    // update our current match information all the time
    Current.follow(function(nodes) {
        var changed = false;
        if (nodes.matches.length > 0) {
            var num = nodes.matches[0].num;
            changed = $scope.current_match != num;
            $scope.current_match = num;
        } else {
            changed = $scope.current_match == null;
            $scope.current_match = null;
        }
        if (changed) {
            // re-calculate the list of unspent matches
            sessions_changed(sessions_cache[false]);
        }
    });

    // update the data only when the state changes
    State.change(function() {
        Teams.get(function(nodes) {
            $scope.teams = nodes.teams;
        });

        MatchPeriods.getSessions(sessions_changed);
    });
});
