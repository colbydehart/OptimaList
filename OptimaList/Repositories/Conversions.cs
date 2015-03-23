using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OptimaList.Repositories
{
    public class Conversions
    {
        public static decimal ConvertToCup(decimal number, string current)
        {
            switch (current)
            {
                case "mL":
                    return number * 0.00422675M;

                case "tsp":
                    return number * 0.0208333M;

                case "tbsp":
                    return number * 0.0625M;

                case "floz":
                    return number * 0.125M;

                case "cup":
                    return number;

                case "pint":
                    return number * 2;

                case "quart":
                    return number * 4;

                case "gallon":
                    return number * 16;

                case "liter":
                    return number * 4.22675M;
            }
            return -1;
        }
        public static decimal ConvertToOz(decimal number, string current)
        {
            switch (current)
            {
                case "oz":
                    return number;

                case "kg":
                    return number * 35.27M;

                case "lb":
                    return number * 16;

                case "g":
                    return number * 0.03527M;

            }
            return -1;

        }
    }
}