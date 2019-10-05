var spreadsheetID = "1rOPD8oQhjfJft9o5yCB0zLR_Xz72UNiqq8KQgvcK7UQ" ;
var select_project = 1;
var sheet_list = []

init()

function init()
{
	load_and_reformat_sheet_json(display)
	
}

function display(json)
{
	console.log(json)
}


function load_and_reformat_sheet_json(func){
var final_json = []
var item_index = 0
var url = "https://spreadsheets.google.com/feeds/list/" + spreadsheetID + "/"+ select_project +"/public/basic?alt=json";
$.getJSON(url, function(data) // Get JSON from google sheet
 	{

 	
 		$.each(data.feed.entry,function(i,column_data) // penetrate each row
		 	
		 {

		
		var item_string = column_data.content.$t;
		item_string = item_string.replace("whatdoyouwantthemedialabtobe:","")
		
		var j = JSON.stringify({"index": item_index , "text": item_string});
		var text_json = JSON.parse(j)
		
		final_json.push (text_json)
		item_index ++
				
		});
		func(final_json)
		
		
 	});
}
 
 