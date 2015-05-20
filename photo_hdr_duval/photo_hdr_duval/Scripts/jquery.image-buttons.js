$(".thumbnail").matchHeight();

$(document).delegate('*[data-toggle="lightbox"]', 'click', function (event) {
    event.preventDefault();
    $(this).ekkoLightbox();
});

$(function () {
   
    $('#photo_gallery').on("mouseenter", ".thumbnail-container", function () {
        $(this).find('.buttons').show();
    });

    $('#photo_gallery').on("mouseleave", ".thumbnail-container", function () {
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
            if ($(".thumbnail-container").length == 0)
                $("#photo_gallery").append("<small>Il n'y a pas encore de photos pour ce rendez-vous</small>");

        }).fail(function () {
            alert('Une erreur est survenue, veuillez réessayer');
        });
    });


});
