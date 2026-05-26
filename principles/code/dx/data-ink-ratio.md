# CODE-DX-DATA-INK-RATIO - Minimize data-ink ratio in visualizations

**Layer:** 2
**Categories:** developer-experience, usability, ux-design
**Applies-to:** all
**Summary:** Maximize the data-ink ratio; remove every visual element that doesn't convey information.

## Principle

In any data visualization, the share of ink (or pixels) devoted to displaying actual data should be maximized, and the share devoted to non-data elements - grid lines, borders, decorations, redundant labels, 3D effects - should be minimized. Tufte defines the data-ink ratio as the proportion of a graphic's ink that represents data. A large share of ink in a typical graphic can be removed without loss of information. Every element in a visualization should earn its place by conveying data or aiding comprehension.

## Why it matters

Visual clutter competes with data for the viewer's attention. Heavy gridlines, chartjunk (decorative elements that do not convey data), and redundant encodings (labeling every bar in a bar chart that already has an axis) make it harder to see patterns, trends, and outliers. Dashboards and monitoring tools that violate this principle waste screen space and cognitive effort, causing users to miss the signals they are looking for.

## Violations to detect

- Charts with heavy gridlines, 3D effects, gradient fills, or decorative images that do not encode data
- Redundant encoding: data labels on every point in a chart that already has clearly labeled axes
- Dashboard widgets with large chrome (borders, headers, padding) and small data areas
- Pie charts used where a bar chart or table would communicate the data more clearly
- Color used for decoration rather than to encode a data dimension

## Good practice

- Remove or lighten gridlines - use faint lines or remove them entirely if axis labels are sufficient
- Eliminate chart borders, background fills, and 3D effects that add no information
- Use direct labeling (placing labels on or next to data elements) instead of legends when there are few series
- Prefer high data-density formats: small multiples, sparklines, and tables over heavily decorated single charts
- Choose the simplest chart type that accurately represents the data - bar charts for comparison, line charts for trends, tables for exact values

## Sources

- Tufte, Edward. *The Visual Display of Quantitative Information*, 2nd ed. Graphics Press, 2001. ISBN 978-0-9613921-4-7. Chapter 6: "Data-Ink Maximization and Graphical Design."
