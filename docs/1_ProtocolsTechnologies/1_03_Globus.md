# Globus and GridFTP for file transfer

Globus is the most popular implementation of the GridFTP protocol. This
is a protocol that is optimized for large data transfers over
high-latency connections that may even lack reliability.

Globus data transfers happen between so-called endpoints. The endpoint
software can be installed on big file servers -- and many supercomputer
centers will offer a Globus endpoint to access your data there -- but
there is also more feature-limited "personal endpoint" software to turn
your desktop or laptop in a Globus endpoint. However, you don't need any
specific software to initiate a data transfer between two endpoints.
This is done via a web interface provided by the Globus service
(globus.org). In this process, your actual data does not pass through
the Globus.org servers nor through the computer on which you initiate
the transfer but is transferred directly between the two end points. If
connections get interrupted, data transfer will be restarted
automatically when the connection is restored.

So, among others, you can:

-   Transfer data between a supercomputer and a file server on your
    department (provided both are Globus endpoints), initiating the
    transfer from your laptop or even smartphone. Ones the data transfer
    is initiated, there is no need to keep your laptop or smartphone
    connected as it is not directly involved in the data transfer.

-   Transfer data between two supercomputers on which you have an
    account (which really is exactly the same case as the previous one).

-   Transfer data to or from your laptop. In this case, you need to
    install personal endpoint software on your laptop and register it
    with the globus.org service. However, you can unplug your laptop
    from the network while the data transfer is going on. The data
    transfer will automatically resume when your laptop is on the
    network again. This makes this a lot more user-friendly technology
    to transfer large amounts of data than sftp, as sftp connections do
    not automatically restart when interrupted.
