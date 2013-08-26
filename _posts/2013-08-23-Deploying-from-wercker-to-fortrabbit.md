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

I have played a bit and came up with the following deployment pipeline that I added to the [wercker.yml](https://github.com/pjvds/php-fortrabbit-sample-app/blob/738f0b69d403b6045f809470bc5b27b97a9f58db/wercker.yml#L18-L56):

{% highlight yaml %}
deploy:
  steps:
    - add-to-known_hosts:
        hostname: $FORTRABBIT_GIT_HOST
    - script:
        name: Setup git repository
        code: |-
          # Remove existing git repository if exists
          if [ -d ".git" ]; then rm -rf .git; fi

          # Configure git user
          git config --global user.name "wercker"
          git config --global user.email pleasemailus@wercker.com

          # Initialize new repository and add everything
          git init
          git add .
          git commit -m 'Deploy commit'

          # Add fortrabbit remote
          git remote add fortrabbit "$FORTRABBIT_GIT_REMOTE"
    - script:
        name: Make .SSH directory
        code: mkdir -p "$HOME/.ssh"
    - create-file:
        name: Write SSH key
        filename: $HOME/.ssh/id_rsa
        overwrite: true
        content: $FORTRABBIT_KEY_PRIVATE
    - script:
        name: Set permissions for SSH key
        code: |-
          chmod 0400 $HOME/.ssh/id_rsa
    - script:
        name: Git push deploy
        code: |-
          git push fortrabbit master -f
{% endhighlight %}

Most steps should be self explaining, but here is what is it does in plain English:
	
	* Trust forstrabbit git hostname, eq: `it2.eu1.frbit.com`
	* Setup git repository and add all files to push
	* Add SSH private key for authentication
	* Git push deploy to fortrabbit

## Add deploy target

The last step is to add an deploy target to the application at wercker. This can be done via the settings tab of the application:

![add deploy target]({{ 'deploying-from-wercker-to-fortrabbit/add-deploy-target.png' | asset_url }})

I name it production, and enable auto deploy for the master branch.

![deploy target basic properties]({{ 'deploying-from-wercker-to-fortrabbit/deploy-target-basic-properties.png' | asset_url }})

We can add environment variables to the deploy target to make information available during the deployment. I start by exposing the SSH key that I have added earlier:

![add ssh key variable]({{ 'deploying-from-wercker-to-fortrabbit/add-key-var.png' | asset_url }})

Next I add the two text variables `FORSTRABBIT_GIT_REMOTE` and `FORSTRABBIT_GIT_HOST`, which I set to the values displayed on the git tab at fortrabbit.

## Deploy!

Navigate to your latest build and choose deploy:

![deploy]({{ 'deploying-from-wercker-to-fortrabbit/deploy.png' | asset_url }})