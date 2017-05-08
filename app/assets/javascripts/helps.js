$(document).on('ready', function() {
    var ToC =
      "<nav role='navigation' class='table-of-contents'>" +
        "<h2>メニュー</h2>" +
        "<ul>";

    var newLine, el, title, link;

    $("article .guide-item .guide-content h3").each(function() {
        // alert($(this).html());
      el = $(this);
      title = el.text();
      // alert();
      link = "#" + el.parent().parent().attr("id");
      newLine =
        "<li>" +
          "<a href='" + link + "'>" +
            title +
          "</a>" +
        "</li>";

      ToC += newLine;

    });

    ToC +=
       "</ul>" +
      "</nav>";
    // alert($(".guide-item").closest(".guide-content").height()-76);
    $(".menu-content").prepend(ToC);
    $(".guide-item").each(function(){
        // alert("ok");
        // alert($(this).children().height());
        $(this).css("height",$(this).children().height()+"px");
    });
    // $(.gui)
    // $(".guide-title").css("height",$(".guide-title").closest(".guide-contenti").height-76+"px")
    // $(".guide-item").css("height","24px")

    // $('.show_pdf_help').click(function(){
    //   $('#view_pdf').attr('data','https://docs.google.com/document/d/1Dd5B6v0HUrymshOC-Cp5NvBGUl-SeTsOILHrfrQHNYQ/edit?usp=sharing#:0.page.2');
    //   // $('object').contents().find('mainContainer').css("overflow","hidden");
    //   // var o = $('object');
    //   // var s = $('html', o[0].contentDocument).animate({scrollTop:1100},500);


    //   // alert(s.find('body,#outerContainer,#mainContainer,#viewerContainer').height());
    //   // $('#view_pdf')[0].animate({scrollTop:1100},500);
    //   // $('#view_pdf').find_element_by_name('mainContainer').animate({scrollTop:1100},500);
    //   // $('#view_pdf').animate({scrollTop:1100},500);
    //   // $('#iframemc').contents().find('body').animate({scrollTop:1100},500);
    //   // $("#iframemc").contents().children().animate({ scrollTop: 1100 }, 500);

    // })
    $('#view_pdf').css("height", $(document).height()+'px');
});


