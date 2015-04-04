/**
 * Created by omeremreaslan on 04/04/15.
 */

  function login(){
    FB.login(function(response) {
        if (response.authResponse) {
            loginFacebook();
        } else {
           document.getElementById('status').innerHTML =
            'Please allow application to know your informations.';
        }
    }, {
        scope: 'public_profile,email'
    });
  }




  window.fbAsyncInit = function() {
  FB.init({
    appId      : '1582121582049659',
    cookie     : false,
    xfbml      : true,
    version    : 'v2.3'
  });

  };

  // Load the SDK asynchronously
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));
