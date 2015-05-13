---
layout: main
title: 2015 Competition Knockout
competition: true
angular_controller: KnockoutTree
---
<style type="text/css">
div.game ul li:nth-child(1) { background-color: {{corners[0].colour|hexLighter:0.2}}; }
div.game ul li:nth-child(2) { background-color: {{corners[1].colour|hexLighter:0.2}}; }
div.game ul li:nth-child(3) { background-color: {{corners[2].colour|hexLighter:0.2}}; }
div.game ul li:nth-child(4) { background-color: {{corners[3].colour|hexLighter:0.2}}; }
</style>

All the teams in this year's competition will enter the knockout stages.
Teams are placed into the initial knockout rounds based on their [league points](/comp/league).
From there, the top two robots in each match will progress to the next round.

<span data-ng-if="latest_scored_match != null && knockout_started">
Up to date with scores from match {{latest_scored_match}}.
</span>

<span data-ng-if="!knockout_started">
The knockouts have not yet started.
See the [match schedule](/comp/schedule) for information about the current match.
</span>

<div id="knockouts">
    <div class="round" data-ng-repeat="round in rounds"
                       data-ng-init="isFinal = $last">
        <div class="match"
             data-ng-repeat="match in round"
             data-ng-class="{current: match.num==current_match}"
             >
            <h4>{{match.description}}</h4>
            <span>{{match.time|date:'HH:mm:ss'}}</span>
            <div class="game" data-ng-repeat="game in match.games">
                <span style="color: {{arenas[game.arena].colour}};">Arena {{arenas[game.arena].display_name}}</span>
                <ul>
                    <li data-ng-repeat="tla in game.teams track by $index">
                        <a data-ng-href="/teams/{{tla}}"
                           data-ng-class="{promote: !isFinal && (game.ranking[tla] == 1 || game.ranking[tla] == 2)}"
                           data-ng-show="{{tla != unknowable && tla != '-'}}"
                           title="Find out more about team {{tla|teamInfo:teams|teamName}}">
                           {{tla}}
                       </a>
                        <span data-ng-show="{{tla == unknowable || tla == '-'}}">
                           {{tla}}
                       </span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
