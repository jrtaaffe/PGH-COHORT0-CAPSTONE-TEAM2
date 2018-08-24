<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />
<script>fnSetTitle("Stock Market Research");</script>

<!-- TradingView Widget BEGIN -->
<div class="tradingview-widget-container">
  <div id="tradingview_77832"></div>
  <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/symbols/NASDAQ-AAPL/" rel="noopener" target="_blank"><span class="blue-text">AAPL chart</span></a> by TradingView</div>
  <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
  <script type="text/javascript">
  new TradingView.widget(
  {
  "width": 750,
  "height": 610,
  "symbol": "NASDAQ:GOOGL",
  "interval": "D",
  "timezone": "Etc/UTC",
  "theme": "Light",
  "style": "3",
  "locale": "en",
  "toolbar_bg": "#f1f3f6",
  "enable_publishing": false,
  "allow_symbol_change": true,
  "container_id": "tradingview_77832"
}
  );
  </script>
</div>
<!-- TradingView Widget END -->

<c:import url="/WEB-INF/jsp/footer.jsp" />