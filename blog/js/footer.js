function footer (){
    $.ajax({
        url: "https://biofermin2.github.io/footer.html",
        cache: false,
        async: false,
        dataType: 'html',
        success: function(html){
            document.write(html);
        }
    });
}
