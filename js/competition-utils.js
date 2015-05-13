
var TEAMS_PER_ARENA = 4;
var EMPTY_CORNER_SYMBOL = '-';

// age of match (by start time) to be hidden when the user wants
// to hide 'old' matches
var MAX_MATCH_AGE = 15 * 60; // 15 minutes in seconds

var compute_offset = function() {
    return function(then, now) {
        now = now || new Date();
        return now - then;
    };
}();

var apply_offset = function() {
    return function(offset, now) {
        now = now || new Date();
        return new Date(now.valueOf() - offset);
    };
}();

var create_follower = function() {
    return function($interval, resource, delay) {
        resource.follow = function(cb, delay_override) {
            var fetch = function() {
                resource.get(cb);
            };
            $interval(fetch, delay_override || delay);
            fetch();
        };
        return resource;
    };
}();

var hex_to_rgba = function() {
    var get_parts = function(hex) {
        if (hex[0] == "#") {
            hex = hex.substring(1);
        }
        var colours = [];
        for (var i=0; i<6; i += 2) {
            var part = hex.substring(i, i+2);
            var int = parseInt(part, 16);
            colours.push(int);
        }
        return colours;
    };
    return function(hex, alpha) {
        var colours = get_parts(hex);
        colours.push(alpha);
        var rgba = "rgba(" + colours.join(", ") + ")";
        return rgba;
    };
}();

var convert_matches = function() {
    return function(matches, arenas) {
        var output = [];
        for (var i=0; i<matches.length; i++) {
            output.push(match_converter(matches[i], arenas));
        }
        return output;
    };
}();

var ensure_whole_arena = function() {
    var teams_per_arena = TEAMS_PER_ARENA;
    var empty_corner_symbol = EMPTY_CORNER_SYMBOL;
    return function(teams) {
        var output = teams.concat([]);
        for (var i=0; i<output.length; i++) {
            if (!output[i]) {
                output[i] = empty_corner_symbol;
            }
        }
        var missing = teams_per_arena - output.length;
        for (; missing > 0; missing--) {
            output = output.concat([empty_corner_symbol]);
        }
        return output;
    };
}();

var match_converter = function() {
    var teams_per_arena = TEAMS_PER_ARENA;
    return function(match, arenas) {
        var output = { 'teams': [] };
        // Get initial data from the first game in the match
        for (var arena in match) {
            var detail = match[arena];
            output.num = detail.num;
            output.display_name = detail.display_name;
            output.time = new Date(detail.times.slot.start);
            output.end_time = new Date(detail.times.slot.end);
            break;
        }
        // Get teams data by iterating over the arenas, thus ensuring
        // that all the arenas are properly represented.
        for (var arena in arenas) {
            var detail = match[arena];
            var arena_teams;
            if (detail) {
                arena_teams = ensure_whole_arena(detail.teams);
            } else {
                // array of given size containing 'undefined' elements
                arena_teams = new Array(teams_per_arena);
            }
            output.teams = output.teams.concat(arena_teams);
        }
        return output;
    };
}();

var group_matches = function() {
    return function(all_games) {
        var matches = [];
        if (all_games.length == 0) {
            return matches;
        }
        var last_num = all_games[0].num;
        var match = {};
        for (var i=0; i<all_games.length; i++) {
            var game = all_games[i];
            if (last_num != game.num) {
                matches.push(match);
                match = {};
                last_num = game.num;
            }
            match[game.arena] = game;
        }
        matches.push(match);
        return matches;
    };
}();

var build_sessions = function() {
    return function(data, cb) {
        if (data.arenas == null || data.matches == null || data.periods == null) {
            // can't do anything, but don't worry -- we'll get called
            // again once we have the data
            return;
        }

        var all_matches = group_matches(data.matches);

        var sessions = [];
        for (var i=0; i<data.periods.length; i++) {
            var period = data.periods[i];
            var matches = [];
            if (period.matches) {
                matches = all_matches.slice(period.matches.first_num,
                                            period.matches.last_num + 1);
                matches = convert_matches(matches, data.arenas);
            }
            sessions.push({
                'arenas': data.arenas,
                'description': period.description,
                'start_time': new Date(period.start_time),
                'end_time': new Date(period.end_time),
                'max_end_time': new Date(period.max_end_time),
                'matches': matches
            });
        }
        cb(sessions);
    };
}();

var matches_for_team = function() {
    return function(input, team) {
        if (input == null || team == null || team.length == 0) {
            return input;
        }
        var output = input.filter(function(game) {
            // contains
            return game.teams.indexOf(team) != -1;
        });
        return output;
    };
}();

var unspent_matches = function() {
    var max_age = MAX_MATCH_AGE;
    var filter_matches = function(matches, when) {
        // todo: binary search?

        if (matches.length == 0) {
            // nothing to do
            return matches;
        }

        if (matches[0].time > when) {
            // all in future
            return matches;
        }

        if (matches[matches.length-1].time < when) {
            // all in past
            return [];
        }

        var output = matches.filter(function(match) {
            return match.time > when;
        });
        return output;
    };
    return function(sessions, hideOldMatches) {
        if (sessions == null || !hideOldMatches) {
            return sessions;
        }
        var output = [];
        var then = new Date();
        then.setTime(then.getTime() - 1000*max_age);
        for (var i=0; i<sessions.length; i++) {
            var session = sessions[i];
            var matches = filter_matches(session.matches, then);
            if (matches.length != 0) {
                var new_session = {
                    'description': session.description,
                    'arenas': session.arenas,
                    'matches': matches
                };
                output.push(new_session);
            }
        }
        return output;
    };
}();

var process_knockout_round = function() {
    var build_game = function(info) {
        var ranking = {};
        if (info.scores) {
            ranking = info.scores.ranking;
        }
        return {
            "arena": info.arena,
            "ranking": ranking,
            "teams": ensure_whole_arena(info.teams)
        };
    };
    var group_games = function(games) {
        // group the given games by number, assuming they're in order.
        var game_groups = [];
        var last_group = null;
        var last_num = null;

        for (var i=0; i<games.length; i++) {
            var game = games[i];
            if (last_num == game.num) {
                last_group.push(game);
            } else {
                last_group = [game];
                last_num   = game.num;
                game_groups.push(last_group);
            }
        }

        return game_groups;
    };
    return function(round) {

        var game_groups = group_games(round);

        var matches = [];
        for (var i=0; i<game_groups.length; i++) {
            var match_games = game_groups[i];
            var number, description, time;
            var game_details = [];
            for (var j=0; j<match_games.length; j++) {
                var game = match_games[j];
                if (j == 0) {
                    number = game.num;
                    description = game.display_name;
                    time = new Date(game.times.slot.start);
                }
                game_details.push(build_game(game));
            }

            matches.push({
                'num': number,
                'description': description,
                'time': time,
                'games': game_details
            });
        }
        return matches;
    };
}();

var process_knockouts = function() {
    return function(rounds, tiebreaker) {
        var output = [];
        for (var i=0; i<rounds.length; i++) {
            output.push(process_knockout_round(rounds[i]));
        }

        if (tiebreaker) {
            output.push(process_knockout_round([tiebreaker]));
        }

        return output;
    };
}();

// node require() based exports.
if (typeof(exports) != 'undefined') {
    exports.compute_offset = compute_offset;
    exports.apply_offset = apply_offset;
    exports.match_converter = match_converter;
    exports.convert_matches = convert_matches;
    exports.matches_for_team = matches_for_team;
    exports.unspent_matches = unspent_matches;
    exports.process_knockouts = process_knockouts;
    exports.process_knockout_round = process_knockout_round;
}
