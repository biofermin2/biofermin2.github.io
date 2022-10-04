function main(){
    $.ajax({
      url: "https://biofermin2.github.io/index.lisp.html",
        cache: false,
        async: false,
        dataType: 'html',
        success: function(html){
        document.write(html);
        }
        });
}
