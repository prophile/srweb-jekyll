
var UNKNOWABLE_TEAM = "???";
var competitionFilters = angular.module('competitionFilters', []);

/// Replaces a plain TLA with an actual team name
competitionFilters.filter('teamName', function($log) {
    var empty_corner_symbol = EMPTY_CORNER_SYMBOL;
    var unknowable_team = UNKNOWABLE_TEAM;

    return function(tla, teams, name_only) {
        if (teams == null || !(tla in teams)) {
            if (tla != empty_corner_symbol && tla != unknowable_team) {
                $log.warn('No information for team: ' + tla);
            }
            return tla;
        }
        name_only = name_only || false;
        var info = teams[tla];
        var name = info.team_name || info.college.name;
        if (name_only) {
            return name;
        }
        return tla + ": " + name;
    };
});

/// Find matches which the given team is in
competitionFilters.filter('containsTeam', function() {
    // implemented in competition-utils.js
    return matches_for_team;
});

/// Exclude matches which have already happened
competitionFilters.filter('unspentMatches', function() {
    // implemented in competition-utils.js
    return unspent_matches;
});

/// Convert the text to title case
competitionFilters.filter('titleCase', function() {
    return function(string) {
        var parts = string.split();
        for (var i=0; i<parts.length; i++) {
            var word = parts[i];
            parts[i] = word[0].toUpperCase() + word.substring(1).toLowerCase();
        }
        return parts.join(" ");
    }
});

/// Convert the text to title case
competitionFilters.filter('hexLighter', function() {
    // implemented in competition-utils.js
    return function(hex, alpha) {
        if (hex == null || alpha == null) {
            return null;
        }
        return hex_to_rgba(hex, alpha);
    };
});
