// Var containing json result from Swapi API
var jsonData = "";

//
$(document).ready(function () {
    $('#filterTypes').on('change', function (e) {
        // Getting value of the select box
        var val = $(this).val();
        // Show all the rows
        $('tbody tr').show();
        // If there is a value hide all the rows except the ones with a type of that value
        if (val) {
            $('tbody tr').not($('tbody tr[type="' + val + '"]')).hide();
            console.log('tbody tr[type="' + val + '"]')
        }
    });

    // Input listener on search edit text
    // Searching in {jsonData} for name and title values and showing in data table only matched rows
    $('#tableSearch').on('input', function (e) {
        var searchString = $(this).val();
        if (searchString === "") {
            $('tbody tr').show();
            return;
        }
        $('tbody tr').hide()
        const options = {
            threshold: 0.0,
            ignoreLocation: true,
            keys: [
                'name',
                'title'
            ]
        }
        const fuse = new Fuse(jsonData, options);
        const result = fuse.search(searchString); // Searching
        $.each(result, function (key, value) {
            var itemId = value.item.id;
            var itemType = value.item.type;
            //showing each row matching id and type
            $('tbody tr').filter($('tbody tr[id="' + itemId + '"][type="' + itemType + '"]')).show();
        });
    });
});

// Sets jsonData variable
function setJsonData(json) {
    jsonData = json
}

// Show modal displaying details of selected item
function showdetailsmodal(type, id) {
    $("#myModal").modal("show");
    document.getElementById('modalTable').innerHTML = "";
    $.each(jsonData, function (key, value) {
        if (value.type === type && value.id === id) {
            $.each(value, function (idx, val) {
                $("#modalTable").append("<tr><th>" + idx + "</th>" + "<td style=\"word-break:break-all;\">" + val + "</td></tr>");
            });

        }
    });

}
