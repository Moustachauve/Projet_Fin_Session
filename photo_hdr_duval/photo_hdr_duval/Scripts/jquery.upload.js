/* By Christophe Gagnier */

$(function () {
    var id_overlay = 'upload_overlay';
    var template_overlay = $('<div id="' + id_overlay + '"><div class="border"><div class="text">Téléverser</div></div></div>');
    var template_loading = $('<div class="white">TEST</div>')

    var fileList = new Array();
    var currentID = 0;
    var dragging = 0;

    var id = $('#RDVID').val();

    var template_preview = '<div class="col-xs-6 col-sm-4 col-md-3 thumbnail-container">' +
                '<div class="buttons">' +
                '<a href="#" class="glyphicon glyphicon-remove delete_image"></a>' +
                '</div>' +
				'<a class="thumbnail" data-toggle="lightbox" data-gallery="photos">' +
				'<img class="class="img-responsive" />' +
				'</a></div>';

    var overlay = $('body').prepend(template_overlay);


    function showOverlay() {
        template_overlay.css('display', 'block');
    }

    function hideOverlay() {
        template_overlay.css('display', 'none');
    }

    function createImage(file) {
        var reader = new FileReader();

        var preview = $(template_preview);
        var img = $('img', preview);
        var link = $('a .thumbnail', preview);

        reader.onload = function (e) {

            $(img).load(function () {
                $(".thumbnail").matchHeight();
            });

            $(img).attr('src', e.target.result);

            $(link).attr('href', e.target.result);
        }
        reader.readAsDataURL(file);

        $("#preview").append(preview);

        fileList[currentID] = file;
        preview.attr('data_photo_id', currentID);

        currentID++;

        showNumberImages();
    }

    function showPreview() {
        if (fileList.length > 0)
            $('#preview_title, #preview').css('display', 'block');
        else
            $('#preview_title, #preview').css('display', 'none');
    }

    // ===== Handle file input =====
    $('#upload').change(function () {
        for (var i = 0; i < this.files.length; i++) {
            createImage(this.files[i]);
        }

        showPreview();
    });

    // ===== Handle drag events =====
    $(document).on('dragover', function (e) {
        e.preventDefault();
        e.stopPropagation();

        showOverlay();
    });

    $(document).on('dragenter', function (e) {
        e.preventDefault();
        e.stopPropagation();

        dragging++;

        showOverlay();
    });

    $(document).on('dragleave', function (e) {
        e.preventDefault();
        e.stopPropagation();

        dragging--;
        if (dragging === 0) {
            hideOverlay();
        }
    });

    $(document).on('drop', function (e) {
        hideOverlay();
        if (e.originalEvent.dataTransfer) {
            var files = e.originalEvent.dataTransfer.files;
            if (files.length) {
                e.preventDefault();
                e.stopPropagation();

                for (var i = 0; i < files.length; i++) {
                    createImage(files[i]);
                }

                showPreview();

            }
        }
    });

    /* ===== Upload handler ===== */

    $('#upload_imgs').click(uploadAllImages);

    function uploadAllImages() {
        var totalImages = getNumberImages();

        if (totalImages == 0) {
            alert('Veuillez sélectionner des photos');
            return;
        }

        var imageDone = 0;

        for (var i = 0; i < fileList.length; i++) {
            if (typeof fileList[i] === "undefined")
                continue;

            var loadingBar = template_loading.clone()

            //"/RDVs/DoUploadPhoto/" + id

            var formData = new FormData();

            formData.append("file" + i, fileList[i]);

            jQuery.ajax({
                type: "POST",
                url: "/PhotoProprietes/DoUploadPhoto/" + id,
                processData: false,
                contentType: false,
                data: formData
            }).always(function () {
                imageDone++;
                if (imageDone == totalImages) {
                    document.location = "/RDVs/details/" + id;
                }
            });
        }
    }

    function getNumberImages() {
        var nb = 0;
        for (var i = 0; i < fileList.length; i++) {
            if (typeof fileList[i] !== "undefined")
                nb++;
        }
        return nb;
    }


    function showNumberImages() {
        var nbElements = getNumberImages();
        $('#preview_number').text('(' + nbElements + ')');

        if (nbElements == 0) {
            $("#preview, #preview_title").hide();
            $('#upload_imgs').addClass("disabled")
        }
        else
            $('#upload_imgs').removeClass('disabled');
    }

    /* ===== Lightroom ===== */

    $(document).delegate('*[data-toggle="lightbox"]', 'click', function (event) {
        event.preventDefault();
        $(this).ekkoLightbox();
    });

    /* ===== Delete ===== */

    $('#preview').on("mouseenter", ".thumbnail, .buttons", function () {
        $(this).parent().find('.buttons').show();
    });

    $('#preview').on("mouseleave", ".thumbnail, .buttons", function () {
        $(this).parent().find('.buttons').hide();
    });

    $('#preview').on('click', '.delete_image', function () {
        var photo_id = $(this).parent().parent().attr('data_photo_id');
        fileList[photo_id] = undefined;
        $(this).parent().parent().remove();

        showNumberImages();
    });

});
