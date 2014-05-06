$(document).ready(function(){
  $('#search-result').dataTable({
      "columnDefs": [
          {
              "targets": [ 1 ],
              "visible": false
          }
      ],
  });
  var table = $('#search-result').DataTable();
  var rowcollection =  table.$(".link_checkbox", {"page": "all"});
  $('#search-result tbody').on( 'change', 'input.link_checkbox', function () {
    $(this).parents('tr').toggleClass('selected');
  });
  $("#search-result").on('change', '#select_all', function(){
    if($(this).is(":checked")){
      rowcollection.each(function(){
        $(this).prop("checked", true);
        $(this).parents("tr").addClass("selected");
      });
    } else{
      rowcollection.each(function(){
        $(this).prop("checked", false);
        $(this).parents("tr").removeClass("selected");
      });
    }
  });

  $('#download_epub').submit( function () {
    posts = [];
    data = table.rows('.selected').data();
    total_len = data.length;
    for(var i=0;i<total_len;i++){
      posts.push(data[i][1]);
    }
    if(posts.length===0){
      alert("Select atleast one of the post");
      return false;
    } else{
      post_ids = posts.join(); 
      $("#post_ids").val(post_ids);
    }
  });

  $("#search_form").submit(function(){
    $("#search_button").button("loading");
    var website_url = $("#search_field").val();
    setInterval(function(){is_blog_downloaded(website_url);}, 3000);
    return false;
  });

  function is_blog_downloaded(website_url){
    $.ajax({
      url: "/blogs/downloaded",
      data: {url: website_url},
      error: function(){
        alert("Something went wrong");
        location.href = document.URL;
      },
      success: function(data, textStatus, xhr){
        if(data.status){
          $("#search_button").data("loading-text", "Redirecting..");
          location.href="/blogs/posts?url=" + website_url;
        } else{
          $("#search_button").data("loading-text", "Downloading..");
        }
      }
    });
  }

});
