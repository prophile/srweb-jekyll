$(function(){
    'use strict';

    $('#topBanner .playActionLink').click(function(e) {
        $('#topBanner')
            .addClass('expanded')
            .prepend($('#videoPlayerHTML').html());

        e.preventDefault();
    });
});
