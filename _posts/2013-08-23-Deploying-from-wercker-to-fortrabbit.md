Today we got a support ticket from a user that wants to deploy his PHP application to [fortrabbit](http://fortrabbit.com/ "fortrabbit homepage"), a PHP as a service provider. To help this customer I decided to create a small sample app and try to deploy it to fortrabbit. This blogpost describes the steps I took. I will give you a short summery right away: It was pretty damn easy!

## The PHP application

I have a very simple PHP application that echo's some cities in json format from the [index.php](https://github.com/pjvds/php-fortrabbit-sample-app/blob/master/index.php). Here is the content of [index.php](https://github.com/pjvds/php-fortrabbit-sample-app/blob/master/index.php):

{% highlight php %}
<?php
$cities = array("Amsterdam", "San Francisco", "Berlin",
                "New York", "Tokyo", "London");

header('Content-Type: application/json');
echo json_encode($cities, JSON_PRETTY_PRINT);
?>
{% endhighlight %}

It also contains some [tests](https://github.com/pjvds/php-fortrabbit-sample-app/blob/master/tests/) and has a small [wercker.yml](https://github.com/pjvds/php-fortrabbit-sample-app/blob/master/wercker.yml) that defines the build pipeline. Here is the content of [wercker.yml](https://github.com/pjvds/php-fortrabbit-sample-app/blob/master/index.php):

{% highlight yaml %}
# Execute the pipeline with the wercker/php box
box: wercker/php
build:
  steps:
    # Install dependencies with composer
    - script:
        name: install dependencies
        code: |-
            composer install --no-interaction
    # Spin webservice and serve site
    - script:
        name: Serve application
        code: php -S localhost:8000 >> /dev/null &
    # Execute integration tests with php unit
    - script:
        name: PHPUnit integration tests
        code: phpunit --configuration phpunit.xml
{% endhighlight %}

## Generating SSH Key

Wercker has the ability to generate SSH keys that are available from the build and deployment pipeline. These can be generated from the application settings tab at wercker. I generate a key with the name `fortrabbit` and wercker shows me the public key.

![generating an ssh key at wercker.com]({{ 'deploying-from-wercker-to-fortrabbit/generating-ssh-key.png' | asset_url }})

## Adding public key to fortrabbit

To be able to git push deploy to fortrabbit we need to add the public key part of the SSH key pair to our application. This can be done in the manage view of your application via the [application overview](https://my.fortrabbit.com/apps).

![application overview]({{ 'deploying-from-wercker-to-fortrabbit/app-overview.png' | asset_url }})

Navigate to the git tab.

![git tab]({{ 'deploying-from-wercker-to-fortrabbit/git-tab.png' | asset_url }})

Enter a name for the git user, I picked wercker and paste the public key part into the big text area.

![git tab]({{ 'deploying-from-wercker-to-fortrabbit/add-key.png' | asset_url }})

Hit the `Save Git Users` button to confirm.

## Deployment pipeline
