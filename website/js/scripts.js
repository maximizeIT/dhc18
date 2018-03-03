(function(){
    //get the background-color for each tile and apply it as background color for the cooresponding screen
    $('.tile').each(function(){
        var $this= $(this),
            page = $this.data('page-name');

        $this.on('click',function(){
          if(page === 'map-page') {
            $('.'+page).css({'background-color': 'white', 'color': 'black'})
                     .find('.close-button').css({'background-color': 'black', 'color': 'white'});
          }else {
            $('.'+page).css({'background-color': '#FCC120', 'color': 'white'})
                     .find('.close-button').css({'background-color': 'black', 'color': 'white'});
          }
          
        });
    });

	  function showDashBoard(){
      for(var i = 1; i <= 3; i++) {
        $('.col'+i).each(function(){
            $(this).addClass('fadeInForward-'+i).removeClass('fadeOutback');
        });
      }
    }

    function fadeDashBoard(){
      for(var i = 1; i <= 3; i++) {
        $('.col'+i).addClass('fadeOutback').removeClass('fadeInForward-'+i);
      }
    }
  
    
  //listen for when a tile is clicked
  //retrieve the type of page it opens from its data attribute
  //based on the type of page, add corresponding class to page and fade the dashboard
  $('.tile').each(function(){
    var $this= $(this),
        pageType = $this.data('page-type'),
        page = $this.data('page-name');
        
    $this.on('click',function(){
      if(pageType === "s-page"){
          fadeDashBoard();
          $('.'+page).addClass('slidePageInFromLeft').removeClass('slidePageBackLeft');
        }
        else{
          $('.'+page).addClass('openpage');
          fadeDashBoard();
        }
    });
  });

  $('#maplink').each(function(){
    var $this= $(this);
  
    $this.on('click',function(){
      $('.search-page').removeClass('slidePageInFromLeft').addClass('slidePageBackLeft');
      // fadeDashBoard();
      $('.map-page').addClass('slidePageInFromLeft').removeClass('slidePageBackLeft');
    });
  });

  //when a close button is clicked:
  //close the page
  //wait till the page is closed and fade dashboard back in
  $('.s-close-button').click(function(){
      $(this).parent().removeClass('slidePageInFromLeft').addClass('slidePageBackLeft');
      showDashBoard();
  });

})();