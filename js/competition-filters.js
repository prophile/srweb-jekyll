
var UNKNOWABLE_TEAM = "???";
var competitionFilters = angular.module('competitionFilters', []);

/// Gets the team info for a given TLA
competitionFilters.filter('teamInfo', function($log) {
    var empty_corner_symbol = EMPTY_CORNER_SYMBOL;
    var unknowable_team = UNKNOWABLE_TEAM;

    return function(tla, teams) {
        if (teams == null || !(tla in teams)) {
            if (tla && tla != empty_corner_symbol && tla != unknowable_team) {
                $log.warn('No information for team: ' + tla);
            }
            return tla;
        }
        var info = teams[tla];
        return info;
    };
});

/// Replaces a team info object with an actual team name
competitionFilters.filter('teamName', function($log) {
    return function(info, name_only) {
        if (typeof(info) == 'string' || !info) {
            // it's a TLA or some other thing we can't do much with
            return info;
        }
        name_only = name_only || false;
        if (name_only) {
            return info.name;
        }
        return info.tla + ": " + info.name;
    };
});

/// Find matches which the given team is in
competitionFilters.filter('containsTeam', function() {
    // implemented in competition-utils.js
    return matches_for_team;
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
    };
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
