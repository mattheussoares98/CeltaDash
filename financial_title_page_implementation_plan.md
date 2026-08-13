# Financial title page implementation plan

1. Show daily financial-title cash flow for the selected enterprise and month.
   - Load only the selected day from `FinancialTitles/GetData`, grouped by day and expiration date.
   - Display daily open receivable, payable, and balance values.
   - Reload when the selected enterprise or date changes and support pull-to-refresh.
2. Add the selected-enterprise monthly analysis.
   - Load up to twelve months grouped by month.
   - Display monthly receivable, payable, and balance trends.
3. Add the enterprise-group summary.
   - Load all authorized enterprise codes as one grouped result.
   - Display group totals and clarify that the API does not split grouped rows by enterprise.
4. Add period comparison and summary cards.
   - Use the comparison-period response and calculated totals where appropriate.
5. Add focused widget and presenter integration tests.
