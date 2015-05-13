---
description: Meet the Student Robotics teams and track their progress throughout the year.
layout: main
title: The Teams
---

<?php
// Relative to 'classes'
require_once("team_info.php");
$teams = array_values(get_team_info());
?>

<h1>Meet the Teams</h1>

<p>
The SR2015 competiton is in full swing and here you can find a list of the teams taking part.
Each team will be updating the photos below as they go so you can easily track their progress.
</p>

<?php
if (count($teams) == 0) {
    echo "<p>No teams have entered a status yet.</p>";
} else {
    $rookie_banner = <<<ROOKIE
    <span class="rookie marker">R</span>
    <span class="rookie banner" title="This is the first time a team from this school or college has enter
    ed Student Robotics">
            Rookie Team
    </span>
ROOKIE;

    echo '<ul id="teams_container">';
    $i = 1;
    foreach ($teams as $team) {
        $rookie = $team->college['rookie'];
        $class = '';
        if ($rookie) {
            $class = ' class="rookie-team"';
        }
        echo "<li", $class, ">";
        echo "<a href=\"" . $team->team_id . "\">";
        if ($rookie) {
            echo $rookie_banner;
        }
        if (!empty($team->thumb))
            echo "<img src=\"/{$team->thumb}\" alt=\"{$team->team_name}'s robot.\" />";
        else
            echo "<img src=\"/images/template/sad_robot_160.jpg\" title=\"Photo by Steve Keys (http://www.flickr.com/photos/stevekeys/, CC BY 2.0)\" alt=\"{$team->team_name} haven't uploaded a photo\" />";
        echo "<p class=\"team_name\">" . $team->team_id . ": " . $team->team_name . "</p>";
        if (!empty($team->college['name']))
            echo "<p class=\"college_name\">" . $team->college['name'] . "</p>";
        echo "</a>";
        echo "</li>";
        if ($i%5 == 0)
                echo "<br class=\"clearboth\" />";
        $i++;
    }
    echo '</ul>';
}
?>

<p>Is your team listed yet?</p>
<p>
Competitors can modify their Team Status via the
<a href="/docs/IDE/shortcuts_menu" title="The shortcuts menu is the little 'v' next to the projects tab">shortcuts menu</a>
in the <a href="/ide/">IDE</a>.
</p>
