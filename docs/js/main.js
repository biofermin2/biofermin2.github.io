function main(){
    $.ajax({
      url: "https://biofermin2.github.io/menu.org.html",
        cache: false,
        async: false,
        dataType: 'html',
        success: function(html){
        document.write(html);
        }
        });
}
