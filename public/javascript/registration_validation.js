function password_validation(password) {
    let password_length = password.value.length;
    if (password_length === 0 || password_length >= 20 || password_length < 7) {
        document.getElementById("password_error").value = "Password length should be between 7 - 20 characters.";
        password.focus();
        return false;
    }
    return true;
}

function registrationValidation() {
    let first_name = document.forms["userRegistration"]["first_name"];
    let last_name = document.forms["userRegistration"]["last_name"];
    let email = document.forms["userRegistration"]["email"];
    let password = document.forms["userRegistration"]["password"];
    let re_enter_password = document.forms["userRegistration"]["re-enter-password"];

    if (first_name.value === "") {
        document.getElementById("first_name_error").innerHTML = "Please enter a valid first name.";
        first_name.focus();
        console.log(document.getElementById("first_name_error").value);
        return false;
    }

    if (last_name.value === "") {
        let last_name_error = document.getElementById("last_name_error");
        last_name_error.innerHTML = "Please enter a valid last name.";
        last_name.focus();
        return false;
    }

    if (password_validation(password) === false) {
        document.getElementById("password_error").innerHTML = "Please enter a valid password.";
        password.focus();
        return false;
    }
    
    if (re_enter_password.value !== password.value) {
        document.getElementById("re_enter_password_error").innerHTML = "Passwords must match."
        re_enter_password.focus();
        return false;
    }

    return true;
}