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
            } else {
                $('.' + page).addClass('openpage');
                fadeDashBoard();
            }
        });
    });

    $('#maplink').each(function() {
        var $this = $(this);

        $this.on('click', function() {
            $('.search-page').removeClass('slidePageInFromLeft').addClass('slidePageBackLeft');
            // fadeDashBoard();
            $('.map-page').addClass('slidePageInFromLeft').removeClass('slidePageBackLeft');
            $('.map-page').css({
                    'background-color': 'white',
                    'color': 'black'
                })
                .find('.close-button').css({
                    'background-color': 'black',
                    'color': 'white'
                });
        });
    });

    $('.s-close-button').click(function() {
        $(this).parent().removeClass('slidePageInFromLeft').addClass('slidePageBackLeft');
        $( "#searchField" ).val('');
        $( "#search-description" ).empty();
        showDashBoard();
    });

})();

// var myCSV = "Species,Identifiant\r\n";
// myCSV += "Species A,320439\r\n";
// myCSV += "Species B,349450\r\n";
// myCSV += "Species C,43435904\r\n";
// myCSV += "Species D,320440\r\n";
// myCSV += "Species E,349451\r\n";
// myCSV += "Species F,43435905\r\n";

// $(function() {
//   function processData(allText) {
//     var record_num = 2; // or however many elements there are in each row
//     var allTextLines = allText.split(/\r\n|\n/);
//     var lines = [];
//     var headings = allTextLines.shift().split(',');
//     while (allTextLines.length > 0) {
//       var tobj = {}, entry;
//       entry = allTextLines.shift().split(',');
//       tobj['label'] = entry[0];
//       tobj['value'] = entry[1];
//       lines.push(tobj);
//     }
//     return lines;
//   }

//   // Storage for lists of CSV Data
//   var lists = [];
//   // Get the CSV Content
//   // $.get("reference.csv", function(data) {
//   //   lists = processData(data);
//   // });
//     lists = processData(myCSV);

//   $("#input-16").autocomplete({
//     minLength: 3,
//     source: lists,
//     select: function(event, ui) {
//       $("#input-16").val(ui.item.label);
//       $("#identifiant").val(ui.item.value);
//       return false;
//     }
//   });
// });