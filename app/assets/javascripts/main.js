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
    alert(total_len);
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
});
