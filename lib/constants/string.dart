// Messages

const String REQUIRED_EMAIL = 'Email is required.';
const String REQUIRED_FULL_NAME = 'Full name is required.';
const String REQUIRED_PHONE_NO = 'Phone no. is required.';
const String REQUIRED_PASSWORD = 'Password is required.';
const String REQUIRED_CONFIRM_PASSWORD = 'Confirm password is required.';
const String REQUIRED_PLATE_NO = 'Plate No. is required.';
const String REQUIRED_BATTERY = 'Battery reading automatically set to 0.';

const String INVALID_EMAIL = 'Please enter a valid Email Address';
const String INVALID_PASSWORD = 'Please enter a password with\n' +
    'Minimum 1 Upper case\n' +
    'Minimum 1 lowercase\n' +
    'Minimum 1 Numeric Number\n' +
    'Minimum 1 Special Character\n' +
    'Common Allow Character';

const String INVALID_CONFIRM_PASSWORD = 'Confirm password does not match.';

const String REG_EXP_EMAIL =
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
const String REG_EXP_PASSWORD =
    r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$";
