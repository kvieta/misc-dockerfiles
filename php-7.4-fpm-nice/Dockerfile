FROM php:7.4-fpm-alpine

# System dependencies
RUN set -eux; \
	\
	apk update;\
	apk upgrade --no-cache;\
	apk add --no-cache \
		git \
		imagemagick \
		# Required for SyntaxHighlighting
		python3 \
	;

# Install the PHP extensions we need
RUN set -eux; \
	\
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		icu-dev \
		oniguruma-dev \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		calendar \
		intl \
		mbstring \
		mysqli \
		opcache \
	; \
	\
	pecl install APCu-5.1.21; \
	docker-php-ext-enable \
		apcu \
	; \
	rm -r /tmp/pear; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --virtual .mediawiki-phpext-rundeps $runDeps; \
	apk del .build-deps

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini


CMD ["php-fpm"]