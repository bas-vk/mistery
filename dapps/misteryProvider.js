/**
 * Returns true if object is array, otherwise false
 *
 * @method isArray
 * @param {Object}
 * @return {Boolean}
 */
var isArray = function(object) {
    return object instanceof Array;
};

var MisteryProvider = function() {
    this.responseCallbacks = {};
    var _this = this;

    this.channel = new QWebChannel(qt.webChannelTransport, function(channel) {
        _this.misteryProvider = channel.objects.misteryProvider;

        // Connect to a signal:
        _this.misteryProvider.message.connect(function(data) {

            _this._parseResponse(data).forEach(function(result) {

                var id = null;

                // get the id which matches the returned id
                if (isArray(result)) {
                    result.forEach(function(load) {
                        if (_this.responseCallbacks[load.id])
                            id = load.id;
                    });
                } else {
                    id = result.id;
                }

                // fire the callback
                if (_this.responseCallbacks[id]) {
                    _this.responseCallbacks[id](null, result);
                    delete _this.responseCallbacks[id];
                }
            });
        });

        // To make the object known globally, assign it to the window object, i.e.:
        //window.misteryProvider = channel.objects.misteryProvider;

        // Invoke a method:
        //misteryProvider.someMethod("hello world", function(returnValue) {
        //    // This callback will be invoked when myMethod has a return value. Keep in mind that
        //    // the communication is asynchronous, hence the need for this callback.
        //    document.getElementById("message").innerHTML = "returnValue: " + returnValue;
        //});

        // Read a property value, which is cached on the client side:
        //console.log(foo.myProperty);

        // Writing a property will instantly update the client side cache.
        // The remote end will be notified about the change asynchronously
        //foo.myProperty = "Hello World!";

        // To get notified about remote property changes,
        // simply connect to the corresponding notify signal:
        //foo.onSomeSignal.connect(function(newValue) {
        //    document.getElementById("message").innerHTML = "signal: " + newValue;
        //});

        // One can also access enums that are marked with Q_ENUM:
        //console.log(foo.MyEnum.MyEnumerator);
    });
}

MisteryProvider.prototype._addResponseCallback = function(request, callback) {
    var id = request.id || request[0].id;
    var method = request.method || request[0].method;

    this.responseCallbacks[id] = callback;
    this.responseCallbacks[id].method = method;
};

MisteryProvider.prototype.isConnected = function() {
    return this.channel.objects.misteryProvider.isConnected;
};

MisteryProvider.prototype.send = function(request) {
    throw new Error('You tried to send "' + request.method + '" synchronously. Synchronous requests are not supported by the IPC provider.');

    //this.misteryProvider.send(JSON.stringify(request));
    //this._addResponseCallback(request, callback);
};

MisteryProvider.prototype.sendAsync = function(request, callback) {
    this.misteryProvider.send(JSON.stringify(request));
    this._addResponseCallback(request, callback);
};

/**
@method _timeout
*/
MisteryProvider.prototype._timeout = function() {
    for (var key in this.responseCallbacks) {
        if (this.responseCallbacks.hasOwnProperty(key)) {
            this.responseCallbacks[key]('Timeout on IPC');
            delete this.responseCallbacks[key];
        }
    }
};

/**
Will parse the response and make an array out of it.
@method _parseResponse
@param {String} data
*/
MisteryProvider.prototype._parseResponse = function(data) {
    var _this = this,
        returnValues = [];

    // DE-CHUNKER
    var dechunkedData = data
        .replace(/\}\{/g, '}|--|{') // }{
        .replace(/\}\]\[\{/g, '}]|--|[{') // }][{
        .replace(/\}\[\{/g, '}|--|[{') // }[{
        .replace(/\}\]\{/g, '}]|--|{') // }]{
        .split('|--|');

    dechunkedData.forEach(function(data) {

        // prepend the last chunk
        if (_this.lastChunk)
            data = _this.lastChunk + data;

        var result = null;

        try {
            result = JSON.parse(data);
        } catch (e) {

            _this.lastChunk = data;

            // start timeout to cancel all requests
            clearTimeout(_this.lastChunkTimeout);
            _this.lastChunkTimeout = setTimeout(function() {
                _this.timeout();
                throw "InvalidResponse " + data;
            }, 1000 * 15);

            return;
        }

        // cancel timeout and set chunk to null
        clearTimeout(_this.lastChunkTimeout);
        _this.lastChunk = null;

        if (result)
            returnValues.push(result);
    });

    return returnValues;
};
