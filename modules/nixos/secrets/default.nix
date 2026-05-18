{ config, ... }: {
  age.rekey = {
    # Every machine inherits this same Yubikey master identity
    masterIdentities = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6NqWkXLJYaxXoNIzS2pxqUdGF/2ItuiGFnV0+n1PaConTxYIikk1HsgvspIBuoSnA+85+wn1tIhRiUocOww8IVKMwAi1X0st5ES96cqCAw4q3th4Bx3C2YiwF1WKWpCR04ZztJhX/5TTp8fVpY3oaOJMN3lKAnxiYdHv7+HP9YP4gUQbpsvrTDguceiZVkmi/c5wmSiAbdlacmU3WSFkVstnJB2C0jmpqFzKnCCRZLA1OKcD/Sknu+gucxP8CFaAt07lfolisfr6DCfOt9JTrnjSYuNmraKAKnxEfqllW+Oj45T9cZX7VVAG4hXfhYWNRY2lI8BCDiOcFe9bNUO2zNtShpPqvgIZnYeOptPfL5SP5iNrG0odKhHTeztE3oHnyukCDLxVUAdBjQb3B57QJ6K5w0Y2z8e4gicpLD3PPrAL0kWAeom0uhKcaFWwwCBqQCSzyUfhr14E9h/TDCgJOZ6IgYJfVeTGJlgH45C9XUF3ztCjQZBSNPP1NsSseCf8iOvw4zdHUJhjPOWgix3DcXLI8V0ftjZ3xbjnzKA4EvCfn4wi5t+XaD0cLn+YkvvLHfK8ivv7AEkuPL3mdlTuCyDLxQVy02jSho933iLv6Z7CIi5/ejWQY9n1rB0dEXoA11dbxZ3PBrzst/cC4RDg0yekSjalriRkEl0vpJlnMFQ== cardno:11_879_817"
    ];

    storageMode = "local";
    # This dynamically generates a unique folder name for every host automatically
    localStorageDir = ./. + "/secrets/rekeyed/${config.networking.hostName}";
  };
}
