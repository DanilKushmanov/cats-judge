# Use an official Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    perl \
    cpanminus \
    build-essential \
    libfile-copy-recursive-perl \
    libxml-parser-perl \
    fpc \
    libdbd-pg-perl \
    libsql-abstract-perl \
    libdbd-firebird-perl

# Add Perl and Git to the PATH
ENV PATH="/usr/bin/perl:/usr/bin/git:${PATH}"

# Clone the cats-judge repository
RUN git clone https://github.com/DanilKushmanov/cats-judge.git /cats-judge

# Set the working directory
WORKDIR /cats-judge

RUN git submodule init && git submodule update

RUN bash -c "apt-get install -y cpanminus build-essential libfile-copy-recursive-perl libxml-parser-perl fpc"

# Add the cats-judge/lib directory to Perl's @INC path
ENV PERL5LIB="/cats-judge/lib"

RUN cpanm --installdeps .
RUN cpanm SQL::Abstract


RUN perl install.pl

# Expose the necessary ports (adjust as needed)
EXPOSE 8080
