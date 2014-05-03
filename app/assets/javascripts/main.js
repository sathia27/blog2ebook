$(document).ready(function(){
  $("#notify").hide();
  $("#search_form").submit(function(){
    $("div.main_content").html();
    search_val = $("#search_field").val();
    $.ajax({
      url: "/blog_list/search?url="+search_val,
      beforeSend: function(){
        $("#notify").show();
        $("#search_button").attr("disabled", "disabled");
      },
      success: function(data){
        $("#notify").hide();
        $("div.main_content").html(data);
        $("#search_button").removeAttr("disabled");
        load_fetch_link_form();
      }
    });
    return false;
  });
});

function load_fetch_link_form(){
  var table = $('div.main_content table').dataTable();
  links = [];
  $(".link_checkbox").change(function(){
    links.push($(this).val());
  });
  $("#download").click(function(){
    if(links.length > 0){
      $.ajax({
        url: "/blog_list/fetch",
        data: {links: links},
        success: function(data){
          console.log(data);
        }
      });
    }
    return false;
  });
}
