#less CEV
FROM ubuntu:jammy
ENV APP_PORT 8080 
#good practice to run app non root user
RUN groupadd --gid 10001 apprun \
    && useradd --uid 10001 --gid apprun --shell /bin/bash --create-home apprun \
    && mkdir /app \
    && chown -R apprun:apprun /app
 
WORKDIR /app
 
USER apprun
 
COPY --chown=apprun:apprun . .
 
EXPOSE ${APP_PORT}/udp
CMD [ "./LinuxServerBuild" ]
