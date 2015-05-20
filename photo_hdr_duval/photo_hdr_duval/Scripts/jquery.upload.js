/* By Christophe Gagnier */

$(function () {
    var id_overlay = 'upload_overlay';
    var template_overlay = $('<div id="' + id_overlay + '"><div class="border"><div class="text">Téléverser</div></div></div>');

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
            //Verify file type


            var buffer = reader.result;
            if(buffer2mime(buffer) == "-1") {
                alert("Le fichier n'est pas une image valide (png, jpg ou gif)");
                return;
            }
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

        var files = e.dataTransfer.files || e.target.files; // File list

        console.log(files);

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

        var formData = new FormData();

        for (var i = 0; i < fileList.length; i++) {
            if (typeof fileList[i] === "undefined")
                continue;

            formData.append("file" + i, fileList[i]);
        }

        jQuery.ajax({
            type: "POST",
            url: "/PhotoProprietes/DoUploadPhoto/" + id,
            processData: false,
            contentType: false,
            data: formData
        }).fail(function (xhr) {
            console.log(xhr);
            alert("Une erreur est survenue: " + xhr.responseText);
        }).success(function () {
            document.location = "/RDVs/details/" + id;
        });

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

    //Mime type
    function buffer2mime(buffer)
    {
        var buf = new Uint8Array(buffer);
        if(buf[0] == 0xFF
        && buf[1] == 0xD8
        && buf[2] == 0xFF
        && buf[3] == 0xE0
        && buf[4] == 0x00
        && buf[5] == 0x10
        && buf[6] == 0x4A  // J
        && buf[7] == 0x46  // F
        && buf[8] == 0x49  // I
        && buf[9] == 0x46) // F
        {
            return "image/jpeg";
        }
        if(buf[0] == 0x89
        && buf[1] == 0x50  // P
        && buf[2] == 0x4E  // N
        && buf[3] == 0x47  // G
        && buf[4] == 0x0D  // \r
        && buf[5] == 0x0A) // \n
        {
            return "image/png";
        }
        if(buf[0] == 0x47  // G
        && buf[1] == 0x49  // I
        && buf[2] == 0x46  // F
        && buf[3] == 0x38  // 8
        && buf[4] == 0x39  // 9
        && buf[5] == 0x61) // a
        {
            return "image/gif";
        }

        // unknown
        return "-1";
    }

    });
