module Ferro (main) where

import Data.Default (def)

import qualified Network.HTTP.Req as Req
import qualified Readability
import qualified Text.URI as Uri
import qualified Text.XML as Xml
import qualified UnliftIO.Environment as Environment


main :: IO ()
main = do
  inputUrl <-
    Environment.getArgs >>= \case
      [] -> die "usage: ferro <url>"
      inputUrl : _ -> pure inputUrl
  bytes <-
    case Uri.mkURI (toText inputUrl) >>= Req.useURI of
      Nothing -> die "Failed to parse URL"
      Just (Left (httpUrl, options)) -> download httpUrl options
      Just (Right (httpsUrl, options)) -> download httpsUrl options
  case Readability.fromByteString bytes of
    Nothing -> die "Failed to make page readable"
    Just article -> putLTextLn $ Xml.renderText def (Readability.summary article)


download :: MonadIO m => Req.Url scheme -> Req.Option scheme -> m LByteString
download url options = Req.runReq Req.defaultHttpConfig do
  response <- Req.req Req.GET url Req.NoReqBody Req.lbsResponse options
  pure (Req.responseBody response)
