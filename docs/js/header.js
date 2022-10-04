function header(){
    $.ajax({
      url: "https://biofermin2.github.io/header.html",
        cache: false,
        async: false,
        dataType: 'html',
        success: function(html){
        document.write(html);
        }
        });
}
