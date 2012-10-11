#!/bin/env ruby

# $Id: stats.rb,v 1.1.1.1 2003/04/13 16:34:56 aerpenbeck Exp $

require "GSL"
include GSL

# Test for Statistics

STDERR.puts "Running statistics tests..."

puts "\nStats:"
#c = [42, 55, 75, 45, 54, 51, 55, 36, 58, 55, 67]
c = [17.2, 18.1, 16.5, 18.3, 12.6]
print "c = ", c.join(" "), "\n"

puts "---"
print "  mean     : ", GSL::Stats::mean(c, 1), "\n"
print "  variance : ", GSL::Stats::variance(c, 1), "\n"
print "  sd       : ", GSL::Stats::sd(c, 1), "\n"
print "  absdev   : ", GSL::Stats::absdev(c, 1), "\n"
print "  skew     : ", GSL::Stats::skew(c, 1), "\n"
print "  kurtosis : ", GSL::Stats::kurtosis(c, 1), "\n"

puts "---"
d = c.sort
print "  max           : ", GSL::Stats::max(c, 1), "\n"
print "  max_index     : ", GSL::Stats::max_index(c, 1), "\n"
print "  min           : ", GSL::Stats::min(c, 1), "\n"
print "  min_index     : ", GSL::Stats::min_index(c, 1), "\n"
a = Stats::minmax(c, 1)
print "  minmax        : ", a[0], " ", a[1], "\n"
a = Stats::minmax_index(c, 1)
print "  minmax_index  : ", a[0], " ", a[1], "\n"
print "  median        : ", GSL::Stats::median_from_sorted_data(d, 1), "\n"
print "  upper quantile: ", GSL::Stats::quantile_from_sorted_data(d, 1, 0.75), "\n"
print "  lower quantile: ", GSL::Stats::quantile_from_sorted_data(d, 1, 0.25), "\n"
#print "  median2  : ", GSL::Stats::median(c, 1), "\n"
#print "  quantile2: ", GSL::Stats::quantile(c, 1, 0.3), "\n"

puts "---"
x = [6, 9, 11, 13, 22, 26, 28, 33, 35]
y = [68, 67, 65, 53, 44, 40, 37, 34, 32]
w = [0.3, 0.5, 0.5, 0.6, 0.8, 0.6, 0.5, 0.5, 0.3]
print "x = ", x.join(" "), "\n"
print "y = ", y.join(" "), "\n"
print "w = ", w.join(" "), "\n"
m1 = GSL::Stats::mean(x, 1)
m2 = GSL::Stats::mean(y, 1)
print "  mean x    : ", m1,  "\n"
print "  mean y    : ", m2,  "\n"
wm = GSL::Stats::wmean(w, 1, y, 1)
print "  wmean y   : ", wm,  "\n"
begin
  print "  covariance: ", GSL::Stats::covariance(x, 1, y, 1), "\n"
rescue GSL::ArgumentError
  STDERR.print "Caught exception: #{$!}\n"
end
#print "  covariance_m: ", GSL::Stats::covariance_m(x, 1, y, 1, m1, m2), "\n"
print "  pvariance : ", GSL::Stats::pvariance(x, 1, y, 1), "\n"

puts "---"
x = [106.9, 106.3, 107.0, 106.0, 104.9]
y = [106.5, 106.7, 106.8, 106.1, 105.6]
print "x = ", x.join(" "), "\n"
print "y = ", y.join(" "), "\n"
m1 = GSL::Stats::mean(x, 1)
m2 = GSL::Stats::mean(y, 1)
print "  mean x    : ", m1,  "\n"
print "  mean y    : ", m2,  "\n"
print "  covariance: ", GSL::Stats::covariance(x, 1, y, 1), "\n"
print "  pvariance : ", GSL::Stats::pvariance(x, 1, y, 1), "\n"
print "  ttest     : ", GSL::Stats::ttest(x, 1, y, 1), "\n"

STDERR.puts "\ndone."
