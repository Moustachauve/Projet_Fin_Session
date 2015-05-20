$(".thumbnail").matchHeight();

$(document).delegate('*[data-toggle="lightbox"]', 'click', function (event) {
    event.preventDefault();
    $(this).ekkoLightbox();
});

$(function () {
    var hoverCount = 0;

    
    $('#photo_gallery').on("mouseenter", ".thumbnail-container", function () {
        hoverCount++;
        $(this).find('.buttons').show();
    });

    $('#photo_gallery').on("mouseleave", ".thumbnail-container", function () {
        /*hoverCount--;
        var _this = this;
        setTimeout(function () {
            if (hoverCount == 0) {
                $(_this).find('.buttons').fadeOut(150);
            }
        }, 5);*/
        $(this).find('.buttons').fadeOut(150);
    });

    $('#photo_gallery').on('click', '.delete_image', function () {
        var photo_id = $(this).parent().parent().attr('id');

        jQuery.ajax({
            type: "POST",
            url: "/PhotoProprietes/DoDeletePhoto/" + photo_id
        }).success(function (dataRaw) {
            var id = JSON.parse(dataRaw);
            $('#' + id).remove();
            hoverCount = 0;

        }).fail(function () {
            alert('Une erreur est survenue, veuillez réessayer');
        });
    });


});
