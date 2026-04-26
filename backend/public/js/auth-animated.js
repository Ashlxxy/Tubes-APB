const container = document.querySelector('.container-auth');
const registerBtn = document.querySelector('.SignUpLink');
const loginBtn = document.querySelector('.SignInLink');

if (registerBtn && container) {
    registerBtn.addEventListener('click', () => {
        container.classList.add('active');
    });
}

if (loginBtn && container) {
    loginBtn.addEventListener('click', () => {
        container.classList.remove('active');
    });
}
