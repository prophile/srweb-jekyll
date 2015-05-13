
var app = angular.module('app', ["competitionFilters", "competitionResources"]);

app.controller("LeaguePoints", function($scope, LastScoredMatch, State, Teams) {
    // Follow changes to the state
    State.change(function() {
        // All the data we need is attached to each team's object
        Teams.getList(function(teams) {
            $scope.teams = teams;
        });

        LastScoredMatch.get(function(points) {
            $scope.latest_scored_match = points.last_scored;
        });
    });
});

app.filter("isTied", function() {
    return function(teamInfo, teams) {
        if (!teamInfo || !teams) {
            return false;
        }
        for (var i=0; i<teams.length; i++) {
            if (teams[i].tla != teamInfo.tla &&
                teams[i].league_pos == teamInfo.league_pos) {
                console.log(teamInfo.tla, "tied with ", teams[i].tla);
                return true;
            }
        }
        return false;
    };
});
