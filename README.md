![image](https://user-images.githubusercontent.com/3678598/97705026-24360700-1a92-11eb-9062-a47497b1e427.png)

This is a proof of concept Ruby On Rails app that utilizes Zype to fetch and display videos from a given content creator.

## Demo

To see this project running visit https://my-vids.herokuapp.com/. You use the following credentials to access the system:
User with subscriptions:
```
email: test@test.com
password: password
```
User without subscriptions:
```
email: test2@test.com
password: password
```

## Gems & Libraries used

- **Zype-gem:** Used to perform some of the API calls needed to Zype servers ([source](https://github.com/zype/zype-gem)).
- **better_settings:** Used as a store of application settings for the rails app ([source](https://github.com/ElMassimo/better_settings)).
- **pry:** Used for development purposes. Allows a better debugging & console experience ([source](https://github.com/pry/pry)).
- **tailwindcss:** Utility first css framework used to build the UI components. Allows fast prototyping. ([source](https://github.com/tailwindlabs/tailwindcss)).

## Dev Setup

You'll need to replace the included `config/development.yml.example` file with `config/development.yml` and fill in all the zype credentails.

## Architecture

My vids leverages the well known MVC paradigm for it's architecture. Besides this, some design patterns were implemented in order to bring calrity, maintenability and extensibility to the structure of the code. 

![zype](https://user-images.githubusercontent.com/3678598/97709680-7f1f2c80-1a99-11eb-9cf1-b6285b28168b.jpeg)
_<p align="center">1. Architecutral diagram</p>_

### Design Patterns

##### Singleton
The singleton pattern was used for the client wrappers of the Zype gem api. The zype gem instantiates a new client every time a request needs to be done. This is not optimal as it will consume more memory. Given the nature of the API client, these can be wrapped with a singleton object in favor of memory consumption.
You can find one of the Zype singleton wrappers [here](https://github.com/mochetts/my-vids/blob/master/app/services/my/videos.rb).

Besides this usage, the singleton pattern was also used to keep the an instance of the current oauth session within the request lifecycle. For this, the Rails `ActiveSupport::CurrentAttributes` class was leveraged ([rails current attributes](https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html)).

##### Decorator
The decorator pattern was used to decorate videos when displaying them to the user. This is a thin wrapper on top of the video model that allows to expose to the views only the properties they need. You can find the video decorator [here](https://github.com/mochetts/my-vids/blob/master/app/decorators/video_decorator.rb).

##### Presenter
The presenter pattern was used to manage the presentation of the list of videos. We want to paginate the list so a presenter is a good and abstract way of managing this pagination. You can find the videos presenter [here](https://github.com/mochetts/my-vids/blob/master/app/presenters/videos_presenter.rb).

##### Adapter
The adapter pattern was used to interface the data store. With a dsl `source_from` declared in the models we are allowed to determine which data source is used for each model. In this demo the Zype wrapper is used, but this can be changed for any other implementation as soon as it meets the interface contract.

### Considerations

##### Session TTL
Zype sessions last for 7 days. However, the requirements are that we need to make sessions last 14 days. So we need to refresh the token granted by the Zype's Oauth mechanism before it expires so that we can use it for the requested time. In order to do so, we keep track of 2 expiration dates: Zype's (7 days) and MyVids (14 days). This allows us to refresh the token one day before Zype's expiration date overriding it by our own session expiration mechanism.

##### Caching
In order to save requests to the Zype API and to bring some performance boost we leveraged rails caching for the videos list and the video details page.

## Next Steps

##### Testing
We need to add testing for the project:
- Unit tests using Rspec.
- UI tests (integration tests) using capybara / selenium.
