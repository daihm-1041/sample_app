const SIZE_FILE_MAX = 5;
const MB_TO_BYTE = 1024;

$(document).on('turbolinks:load', function () {
  $('#micropost_image').on('change', function() {
    let size_in_megabytes = this.files[0].size/MB_TO_BYTE/MB_TO_BYTE;
    if (size_in_megabytes > SIZE_FILE_MAX) {
      alert(I18n.t("errors.messages.file_size_out_of_range"));
      $(this).val(null);
    }
  });
});
