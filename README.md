### Debug `lassa_sentinel` on MacOS

First build the docker image - clone this repo into the same parent directory as the `lassa_sentinel` repo, e.g. you may have `~/projects/lassa_sentinel` and `~/projects/docker-renv`. Then in terminal navigate to the `docker-renv` directory and run this command:

```
docker build -t lassa_r451 .

```

This won't take as long as the previous image as it's not installing all the dependencies listed in the `renv.lock` file. Once it's complete run:

```
docker run --rm -p 8889:8787 -e ROOT=TRUE -e PASSWORD=<ANY_PASSWORD> -v <YOUR_PATH_TO_lassa_sentinel_REPO>:/home/rstudio/lassa_sentinel lassa_r451
```

Then once this is running, open http://localhost:8889/ and log in as username `rstudio` password `<YOUR_PASSWORD>`, and ensure you are not using `renv` via the console in Rstudio: 

```
renv::deactivate()
```

Finally, open the `.Rproj` file in `/home/rstudio/lassa_sentinel` in Rstudio. You should now be able to run `/scripts/03_forecast_monthly/04_generate_forecast.R`, which installs `INLA` and other dependencies at the top of the file (need to re-do this each time the Docker image restarts, I think). 

Image may need to be updated once again if new versions of `INLA` start causing problems. 