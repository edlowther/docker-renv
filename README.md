### Debug `lassa_sentinel` on MacOS

First build the docker image - clone this repo into the same parent directory as the `lassa_sentinel` repo, e.g. you may have `~/projects/lassa_sentinel` and `~/projects/docker-renv`. Then in terminal navigate to the `docker-renv` directory and run this command:

```
docker build -t lassa_minimal .

```

This will take some time, then once it's complete run:

```
docker run --rm -p 8889:8787 -e ROOT=TRUE -e PASSWORD=<ANY_PASSWORD> -v <YOUR_PATH_TO_lassa_sentinel_REPO>:/home/rstudio/lassa_sentinel lassa_minimal
```

Then once this is running, open http://localhost:8889/ and log in as username `rstudio` password `<YOUR_PASSWORD>`, and open the terminal in Rstudio: 

```
sudo RUN R -e "install.packages('INLA', repos=c(getOption('repos'), INLA='https://inla.r-inla-download.org/R/stable'), type='source')"
```

Finally, open the `.Rproj` file in `/home/rstudio/lassa_sentinel` in Rstudio - all the dependencies should now be available. 