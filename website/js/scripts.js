(function() {

    $('.tile').each(function() {
        var $this = $(this),
            page = $this.data('page-name');

        $this.on('click', function() {
            if (page === 'map-page') {
                $('.' + page).css({
                        'background-color': 'white',
                        'color': 'black'
                    })
                    .find('.close-button').css({
                        'background-color': 'black',
                        'color': 'white'
                    });
            } else {
                $('.' + page).css({
                        'background-color': '#FCC120',
                        'color': 'white'
                    })
                    .find('.close-button').css({
                        'background-color': 'black',
                        'color': 'white'
                    });
            }

        });
    });

    function showDashBoard() {
        for (var i = 1; i <= 3; i++) {
            $('.col' + i).each(function() {
                $(this).addClass('fadeInForward-' + i).removeClass('fadeOutback');
            });
        }
    }

    function fadeDashBoard() {
        for (var i = 1; i <= 3; i++) {
            $('.col' + i).addClass('fadeOutback').removeClass('fadeInForward-' + i);
        }
    }

    $('.tile').each(function() {
        var $this = $(this),
            pageType = $this.data('page-type'),
            page = $this.data('page-name');

        $this.on('click', function() {
            if (pageType === "s-page") {
                fadeDashBoard();
                $('.' + page).addClass('slidePageInFromLeft').removeClass('slidePageBackLeft');
            }
        });
    });

    $('#btnLogin').each(function() {
        var $this = $(this);

        $this.on('click', function() {
            
            var AID = $('#aidField').val();

            if(AID === 'P123') {
                $('.login-page').removeClass('slidePageInFromLeft').addClass('slidePageBackLeft');
                $('.patient-page').removeClass('slidePageBackRight')
                $('.patient-page').addClass('slidePageInFromRight').removeClass('slidePageBackLeft');
                $('.patient-page').css({
                        'background-color': 'white',
                        'color': 'black'
                    })
                    .find('.close-button').css({
                        'background-color': 'black',
                        'color': 'white'
                    });

            } else if(AID === 'M123') {
                $('.login-page').removeClass('slidePageInFromLeft').addClass('slidePageBackLeft');
                $('.mgmt-page').removeClass('slidePageBackRight')
                $('.mgmt-page').addClass('slidePageInFromRight').removeClass('slidePageBackLeft');
                $('.mgmt-page').css({
                        'background-color': 'white',
                        'color': 'black'
                    })
                    .find('.close-button').css({
                        'background-color': 'black',
                        'color': 'white'
                    });
            } else if(AID === 'S123') {
                $('.login-page').removeClass('slidePageInFromLeft').addClass('slidePageBackLeft');
                $('.staff-page').removeClass('slidePageBackRight')
                $('.staff-page').addClass('slidePageInFromRight').removeClass('slidePageBackLeft');
                $('.staff-page').css({
                        'background-color': 'white',
                        'color': 'black'
                    })
                    .find('.close-button').css({
                        'background-color': 'black',
                        'color': 'white'
                    });
            } else {
                // none
                // show invald message
            }
        });
    });

    $('.s-close-button').click(function() {
        $(this).parent().removeClass('slidePageInFromLeft').addClass('slidePageBackLeft');
        $( "#searchField" ).val('');
        $( "#search-description" ).empty();
        showDashBoard();
    });

    $('.r-logout-button').click(function() {
        $(this).parent().removeClass('slidePageInFromRight').addClass('slidePageBackRight');
        $( "#aidField" ).val('');
        showDashBoard();
    });

})();