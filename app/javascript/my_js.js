//= require jquery3
//= require jquery_ujs

var MovieListFilter = {
    filter_adult: function() {
        if ($(this).is(':checked')) {
            $('tr.adult').hide();
        } else {
            $('tr.adult').show();
        };
    },
    setup: function() {

        var labelAndCheckbox =
            $('<label for="filter">Only movies suitable for children</label>' +
                '<input type="checkbox" id="filter"/>');
        labelAndCheckbox.insertBefore('#movies');
        $('#filter').prop('checked', true).change(MovieListFilter.filter_adult)
        $('tr.adult').hide();
    }
}
$(MovieListFilter.setup);

var MoviePopup = {
    setup: function() {
        // add hidden 'div' to end of page to display popup:
        var popupDiv = $('<div id="movieInfo"></div>');
        popupDiv.hide().appendTo($('body'));
        $(document).on('click', '#movies a', MoviePopup.getMovieInfo);
    },
    getMovieInfo: function() {
        console.log("click")
        $.ajax({
            type: 'GET',
            url: $(this).attr('href'),
            timeout: 5000,
            success: MoviePopup.showMovieInfo,
            error: function(xhrObj, textStatus, exception) { alert('Error!'); }
                // 'success' and 'error' functions will be passed 3 args
        });
        return (false);
    },
    showMovieInfo: function(data, requestStatus, xhrObject) {
        console.log("success", $('#movieInfo'))
        var oneFourth = Math.ceil($(window).width() / 4);
        $('#movieInfo').css({ 'left': oneFourth, 'width': 2 * oneFourth, 'top': 69 }).html(data).show();
        $('#closeLink').click(MoviePopup.hideMovieInfo);
        return (false);
    },
    hideMovieInfo: function() {
        $('#movieInfo').hide();
        return (false);
    }
};
$(MoviePopup.setup);