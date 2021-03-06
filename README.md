![image](https://user-images.githubusercontent.com/3678598/97705026-24360700-1a92-11eb-9062-a47497b1e427.png)

<h1 align="center">
  <p align="center">
    <a href="https://travis-ci.org/mochetts/my-vids">
      <img alt="Build Status" src="https://travis-ci.org/mochetts/my-vids.svg"/>
    </a>
    <a href='https://coveralls.io/github/mochetts/my-vids?branch=master'>
      <img src='https://coveralls.io/repos/github/mochetts/my-vids/badge.svg?branch=master' alt='Coverage Status' />
    </a>
  </p>
</h1>

This is a proof of concept Ruby On Rails app that utilizes Zype to fetch and display videos from a given content creator.

## Demo

To see this project running visit https://my-vids.herokuapp.com/. Use any of the following credentials to access the system:

**User with subscriptions**
```
email: test@test.com
password: password
```

**User without subscriptions:**
```
email: test2@test.com
password: password
```

_Disclaimer: Give the page some time to load. It's using the free version of heroku which puts the server to sleep after some time of inactivity. So it may need to spin it back up._

## Gems & Libraries used

- **zype-gem:** Used to perform some of the API calls needed to Zype servers ([source](https://github.com/zype/zype-gem)).
- **better_settings:** Used as a store of application settings ([source](https://github.com/ElMassimo/better_settings)).
- **pry:** Used for development purposes. Allows a better debugging & console experience ([source](https://github.com/pry/pry)).
- **tailwindcss:** Utility first css framework used to build the UI components. Allows fast prototyping. ([source](https://github.com/tailwindlabs/tailwindcss)).

## Development Setup

You'll need to copy and rename the included `config/development.yml.example` file with `config/development.yml` and fill in all the zype credentials.

## Production Setup

You'll need to add the following environment variables to your server:
- ZYPE_API_KEY : _Zype's api key_
- ZYPE_APP_KEY : _Zype's app key_
- ZYPE_CLIENT_ID : _Zype's client id_
- ZYPE_CLIENT_SECRET : _Zype's client secret_

You can get these from Zype's admin tool.

## Architecture

My Vids leverages the well known MVC paradigm for its architecture. Besides this, some design patterns were implemented in order to bring calrity, maintenability and extensibility to the code.

![My Vids](https://user-images.githubusercontent.com/3678598/98251578-a2455280-1f57-11eb-9148-175f85c01f52.png)
_<p align="center">1. Architectural diagram</p>_

### Design Patterns

##### Singleton
The singleton pattern was used for the API client wrappers of the Zype gem. The zype gem instantiates a new client every time a request needs to be done. This is not optimal as in the long term, it will consume unnecessary memory. Given the nature of the API client, these can be wrapped withing a singleton object and avoid that excess of memory consumption.
You can find one of the Zype singleton wrappers [here](https://github.com/mochetts/my-vids/blob/master/app/services/my/videos.rb).

Besides this usage, the singleton pattern was used to keep an instance of the current oauth session within the request lifecycle. For this, the Rails `ActiveSupport::CurrentAttributes` class was leveraged ([rails current attributes](https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html)).

##### Decorator
The decorator pattern was used to decorate videos when displaying them to the user. This is a thin wrapper on top of the video model that allows to expose to the views only the properties they need. You can find the video decorator [here](https://github.com/mochetts/my-vids/blob/master/app/decorators/video_decorator.rb).

##### Presenter
The presenter pattern was used to manage the presentation of the videos library. We want to paginate the list so a presenter is a good and abstract way of managing this pagination. You can find the library presenter [here](https://github.com/mochetts/my-vids/blob/master/app/presenters/library_presenter.rb).

##### Adapter
The adapter pattern was used to interface the data store. With a dsl `source_from` declared in the models we are able to determine which data source is used for each model. In this demo, only Zype wrappers were implemented and used, but this can be changed for any other implementation that fulfills the interface contract.

### Considerations

##### Session TTL
Zype sessions last for 7 days. However, the requirements are that we need to make sessions to last 14 days. This means that we need to refresh the token granted by Zype's Oauth mechanism before it expires so that we can keep the session alive for the required time. In order to do so, we keep track of 2 expiration dates
: Zype's (7 days) and MyVids (14 days). This allows us to refresh Zype's token one day before its expiration and leave the session expiration mechanism to MyVids.

For this, an `OauthSession` model is present as part of the models structure. This model inherits all the attributes from zype's oauth authentication response. Besides that, the attributes of this model get persisted to the web session so that user's can stay logged in for the requested 14 days.

##### Caching
In order to save requests to the Zype API and bring a performance boost to the user experience we leveraged rails caching for the videos list and the video details page.

## Testing

For now, we only have rspec testing for the project. To run the tests:

```bash
$ bundle exec rspec
```

We also have code coverage in place. So after running the above command, you can run this one:

```bash
open coverage/index.html
```

...to see the resulting code coverage.

## Next Steps

- Add UI tests (integration tests) using capybara / selenium.
- Implement the "Subscribe" functionality.
