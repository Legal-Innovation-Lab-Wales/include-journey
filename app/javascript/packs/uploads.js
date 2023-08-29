// Declare variables
const upload_input = document.querySelector("input[type='file']");
const file_holder = document.getElementById("file-holder");
const file_error = document.getElementById("file-error");
const drop_div = document.getElementById("file-drag-div");
const cached_file_input = document.getElementById("upload_cached_file");
const change_file_button = document.querySelector(".change-file");
const upload_name_element = document.getElementById("upload_name");

// Import default pdf image
const pdfImage = new Image();
pdfImage.src = require('../images/pdf-image.png');


drop_div?.addEventListener('dragover', (e) => {
    e.preventDefault();
    drop_div.classList.add('dragging')
  });
  
drop_div?.addEventListener('dragstart', (e) => {
e.preventDefault();
});

drop_div?.addEventListener('dragend', (e) => {
e.preventDefault();
drop_div.classList.remove('dragging')
});

drop_div?.addEventListener('drop', (e)=>{
e.preventDefault()
let file = e.dataTransfer.files[0];
processFile(file)
drop_div.classList.remove('dragging')
})

// Add function to display error
function file_error_handler() {
    file_error.innerHTML = 'Please ensure that your file selection is limited to JPEG, PNG, or PDF formats, with a maximum file size of 250MB.';
    upload_input.value = null; // Clear the file input to allow re-selection
}

// Add function to display image
function displayFile(file) {
    const reader = new FileReader();
    reader.onload = function (event) {
      const image = new Image();
      if (file.type === 'application/pdf') {
        // Set the source to the default PDF image location
        image.src = pdfImage.src;
      } else {
        // Set the source to the data URL of the image file
        image.src = event.target.result;
      }
      image.classList.add("img-fluid");
      file_holder.innerHTML = "";
      file_error.innerHTML = "";
      change_file_button.classList.remove("d-none");
      file_holder.append(image);
      cached_file_input.value = event.target.result.split(",")[1];
      displayFileName(file.name);
    };
    reader.readAsDataURL(file);
}

function displayFileName(fileName) {
  if (upload_name_element) {
    upload_name_element.value = fileName;
  }
}

function extractFileData(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onloadstart = function () {
      };

      reader.onprogress = function (event) {
      };
      reader.onload = function (event) {
        const bytes = new Uint8Array(event.target.result);

        const is_jpeg =
          bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff;
        const is_png =
          bytes[0] === 0x89 &&
          bytes[1] === 0x50 &&
          bytes[2] === 0x4e &&
          bytes[3] === 0x47;
        const is_pdf =
          bytes[0] === 0x25 &&
          bytes[1] === 0x50 &&
          bytes[2] === 0x44 &&
          bytes[3] === 0x46;

        if (!is_jpeg && !is_png && !is_pdf) {
          file_error_handler();
          return;
        }
  
        displayFile(file);
      };
      reader.onloadend = function () {
      };
      reader.onerror = function (event) {
        reject(event);
      };
      if (!file) {
        reject();
      }
      reader.readAsArrayBuffer(file);
    });
}

function handleUpload(event) {
    const file = event.target.files[0];
    processFile(file)
}

async function processFile(file) {
    try {
      // Check the file size
      const maxFileSize = 5 * 1024 * 1024;
      if (file.size > maxFileSize) {
        file_error_handler();
        return;
      }
      // If the file size is within the limit, continue with processing
      await extractFileData(file);
    } catch (error) {
      file_error_handler();
    }
  }

upload_input?.addEventListener("change", handleUpload);
