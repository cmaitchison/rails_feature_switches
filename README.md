# The weapon of choice in the fight to resolve the paradox between Continuous Integration and Continuous Delivery is feature switching.

If you are not integrating your code to origin/master at least once day then you are not doing Continuous Integration.

If you are Continuously Integrating code that is not ready to be deployed to production, then you are going to cause attempts at Continuous Delivery to spectacularly fail.

So what about the features that are going to take longer than a day, which you want to keep integrating daily so you don't get a big scary merge at the end, but which is not going to be something that is going to be usable in production until it is done.

## Enter Feature Switching.

This is a very simple implementation of feature switching in Rails.  I am sure there are many other ways to do it.  This is the way that makes most sense to me.

## Getting Started

* Clone the repository to your local machine and go into the project directory.
* bundle install
* bundle exec rake db:migrate
* bundle exec rails server

Now navigate to localhost:3000 and see that there is a page stating that "feature_a" is disabled.

* bundle exec rails console
* (in Rails console) FeatureSwitch.enable "feature_a"

Now refresh the page at localhost:3000 and see that the feature is now enabled.

## There are a few considerations that may not be immediately obvious when implementing feature switching.

* If you only define whether features are enabled or not in a config file that is deployed with the app, then you can not enable/disable features at run-time.
* If you do go down a path of defining whether features are enabled or not in a config file, and you intend to continually re-read that file to enable changes at runtime, then that file has to always be exactly the same on all servers if you deploy to more than one server.
* If you add features to a file that is deployed with the app, and plan on it being read once for the initial status of features and then have it maintain a data structure that can be dynamically updated later, then you cannot deploy to more than one server as each instance of the application will need to read the config file and maintain its own 'FeatureSwitches' data structure.

In my opinion, the simplest solution is to add an ActiveRecord class to maintain the status of various features.  By keeping the state in the database, all servers have exactly the same view of the state.  By using ActiveRecord, you get the benefit of easy integration with the rest of the code.

## Syntax

    if FeatureSwitch.enabled? "feature_a"
      # show the UI element that is the hook into feature_a
    else
      # don't
    end

"feature_a" does not need to be declared in any config file.  It will be added to the db at the point where it is first referenced in the code.

In this very simple implementation, manipulation of the FeatureSwitches is easiest done through the rails console.  In some production environments the rails console will be accessible.  In others, a Capistrano task or a page in the UI could be built to manipulate the features.

The syntax to toggle features is:

    FeatureSwitch.enable "feature_a"
    FeatureSwitch.disable "feature_a"

If feature_a does not exist when these commands are executed, it will be created.

## Don't forget to remove Feature Switches for features which have become stable!

## How to pimp this simple code:

- Add some sort of caching to the FeatureSwitch.enabled? check
- Add sample Rake/Capistrano tasks to enable/disable a feature
- Add tasks to list all features that are being switched.