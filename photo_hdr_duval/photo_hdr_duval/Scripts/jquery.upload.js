$(function () {
	var id_overlay = 'upload_overlay';
	var template_overlay = $('<div id="' + id_overlay + '"><div class="border"><div class="text">Téléverser</div></div></div>');

	var fileList = new Array();
	var currentID = 0;
	var dragging = 0;

	var template_preview = '<div class="col-xs-6 col-sm-4 col-md-3">' +
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
		var link = $('a', preview);

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
		$(img).data('img_id', currentID);

		currentID++;
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

		console.log('Dragover');
		showOverlay();
	});

	$(document).on('dragenter', function (e) {
		e.preventDefault();
		e.stopPropagation();

		dragging++;

		console.log('Dragenter');
		showOverlay();
	});

	$(document).on('dragleave', function (e) {
		e.preventDefault();
		e.stopPropagation();

		dragging--;
		if (dragging === 0) {
			console.log('Dragleave');
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

	/* ===== Lightroom ===== */

	$(document).delegate('*[data-toggle="lightbox"]', 'click', function (event) {
		event.preventDefault();
		$(this).ekkoLightbox();
	});
});
