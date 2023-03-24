function header(){
    $.ajax({
      url: "./header.html",
        cache: false,
        async: false,
        dataType: 'html',
        success: function(html){
        document.write(html);
        }
        });
}
